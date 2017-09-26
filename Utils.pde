abstract class Corners {
    abstract float left();
    abstract float right();
    abstract float top();
    abstract float bottom();

    boolean touching(float x, float y) {
        return x >= left() && x <= right() && y >= top()  && y <= bottom();
    }

    boolean touchingRect(Corners rect) {
        return !(
            left() > rect.right()  || right()  < rect.left() ||
            top()  > rect.bottom() || bottom() < rect.top()
        );
    }
}