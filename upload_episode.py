#!/usr/bin/env python3
import os, sys, json, subprocess, datetime
from pathlib import Path
from moviepy.editor import VideoFileClip, concatenate_videoclips, AudioFileClip, CompositeVideoClip, TextClip
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from PIL import Image, ImageDraw, ImageFont

# ------------------- CONFIG -------------------
SCOPES = ["https://www.googleapis.com/auth/youtube.upload"]
BASE_DIR = Path(__file__).parent
EPISODE_ROOT = BASE_DIR / "episodes"
ASSETS = BASE_DIR / "assets"
THUMB_TEMPLATE = BASE_DIR / "thumb_template.png"   # optional background image
FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"  # adjust for your OS
# ------------------------------------------------

def get_credentials():
    token_path = BASE_DIR / "token.json"
    if token_path.exists():
        creds = Credentials.from_authorized_user_file(str(token_path), SCOPES)
    else:
        flow = InstalledAppFlow.from_client_secrets_file(str(BASE_DIR / "yt_client_secret.json"), SCOPES)
        creds = flow.run_local_server(port=0)
        token_path.write_text(creds.to_json())
    return creds

def build_youtube():
    return build("youtube", "v3", credentials=get_credentials())

def make_thumbnail(ep_num, title):
    # 1280×720, white background, bold black text
    img = Image.new("RGB", (1280, 720), color="#ffffff")
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT_PATH, 80)
    # Title centered
    w, h = draw.textsize(title, font=font)
    draw.text(((1280 - w) / 2, (720 - h) / 2), title, fill="#000000", font=font)
    # Episode number in top‑left corner
    font_small = ImageFont.truetype(FONT_PATH, 40)
    draw.text((30, 30), f"Ep ep_num:02d}", fill="#555555", font=font_small)
    thumb_path = BASE_DIR / f"thumb_ep{ep_num:02d}.jpg"
    img.save(thumb_path, "JPEG", quality=95)
    return thumb_path

def make_short_clip(full_path, out_path, start_sec=30, duration=15):
    clip = VideoFileClip(str(full_path)).subclip(start_sec, start_sec + duration)
    clip.write_videofile(str(out_path), codec="libx264", fps=30, preset="fast", audio=True, verbose=False, logger=None)

def assemble_video(ep_dir):
    raw = VideoFileClip(str(ep_dir / "raw.mp4"))
    clips = []

    # optional intro/outro
    intro_path = ASSETS / "intro.mp4"
    outro_path = ASSETS / "outro.mp4"
    if intro_path.exists():
        clips.append(VideoFileClip(str(intro_path)))
    clips.append(raw)
    if outro_path.exists():
        clips.append(VideoFileClip(str(outro_path)))

    # add background music if present
    music_path = ASSETS / "music.mp3"
    if music_path.exists():
        music = AudioFileClip(str(music_path)).volumex(0.1)  # low volume
        final = concatenate_videoclips(clips, method="compose")
        final = final.set_audio(music.set_duration(final.duration))
    else:
        final = concatenate_videoclips(clips, method="compose")

    out_path = ep_dir / "final.mp4"
    final.write_videofile(str(out_path), codec="libx264", fps=30, preset="fast", audio=True, verbose=False, logger=None)
    return out_path

def upload_video(youtube, video_path, title, description, tags, thumbnail_path):
    body = {
        "snippet": {
            "title": title,
            "description": description,
            "tags": tags,
            "categoryId": "22"   # People & Blogs
        },
        "status": {"privacyStatus": "public"}
    }
    request = youtube.videos().insert(
        part="snippet,status",
        body=body,
        media_body=str(video_path)
    )
    response = request.execute()
    video_id = response["id"]
    # thumbnail
    youtube.thumbnails().set(
        videoId=video_id,
        media_body=str(thumbnail_path)
    ).execute()
    return video_id

def main():
    if len(sys.argv) != 2:
        print("Usage: python upload_episode.py <episode-number>")
        sys.exit(1)

    ep_num = int(sys.argv[1])
    ep_dir = EPISODE_ROOT / f"{ep_num:02d}"
    if not ep_dir.is_dir():
        print(f"Folder {ep_dir} not found.")
        sys.exit(1)

    # 1️⃣ Assemble final video
    final_video = assemble_video(ep_dir)

    # 2️⃣ Create thumbnail
    title = (ep_dir / "title.txt").read_text().strip()
    thumb_path = make_thumbnail(ep_num, title)

    # 3️⃣ Create Shorts clip (optional, saved next to final video)
    short_path = ep_dir / f"short_ep{ep_num:02d}.mp4"
    make_short_clip(final_video, short_path)

    # 4️⃣ Build description (simple template)
    description = f"""\
{title}
🧪 Vegan Biohacking Routine – Episode {ep_num}
🔗 Repository: https://github.com/adacaccia/VeganBiohackingRoutine
📅 Published on {datetime.date.today().isoformat()}

---  
#vegan #biohacking #nutrition
"""
    tags = ["vegan", "biohacking", "nutrition", f"episode{ep_num}", "vegan B12"]

    # 5️⃣ Upload
    youtube = build_youtube()
    video_id = upload_video(youtube, final_video, title, description, tags, thumb_path)

    print(f"✅ Uploaded! Watch at https://youtu.be/{video_id}")
    print(f"📹 Short clip saved at {short_path}")

if __name__ == "__main__":
    main()
